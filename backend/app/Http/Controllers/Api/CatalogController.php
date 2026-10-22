<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

/**
 * Shared list / show / create / update / delete logic
 * for Hotels, Places and Restaurants.
 */
abstract class CatalogController extends Controller
{
    abstract protected function model(): string;

    abstract protected function rules(): array;

    protected function searchable(): array
    {
        return ['name', 'city'];
    }

    // GET /api/{items}?search=angkor&city=Siem Reap&per_page=15
    public function index(Request $request): JsonResponse
    {
        $query = ($this->model())::query();

        if ($search = $request->query('search')) {
            $query->where(function ($q) use ($search) {
                foreach ($this->searchable() as $column) {
                    $q->orWhere($column, 'like', "%{$search}%");
                }
            });
        }

        if ($city = $request->query('city')) {
            $query->where('city', $city);
        }

        return response()->json(
            $query->orderByDesc('rating')->paginate($request->integer('per_page', 15))
        );
    }

    // GET /api/{items}/{id}
    public function show(int $id): JsonResponse
    {
        $item = ($this->model())::withAvg('reviews', 'rating')
            ->withCount('reviews')
            ->findOrFail($id);

        return response()->json($item);
    }

    public function store(Request $request): JsonResponse
    {
        $item = ($this->model())::create($request->validate($this->rules()));

        return response()->json($item, 201);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $item = ($this->model())::findOrFail($id);
        $rules = collect($this->rules())->map(fn ($rule) => 'sometimes|' . $rule)->all();
        $item->update($request->validate($rules));

        return response()->json($item);
    }

    public function destroy(int $id): Response
    {
        ($this->model())::findOrFail($id)->delete();

        return response()->noContent();
    }
}
